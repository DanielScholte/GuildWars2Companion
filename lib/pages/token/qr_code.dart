import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  QRViewController controller;

  String lastQrScanned = "";
  bool canScan = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (previous, current) => current is UnauthenticatedState || current is LoadingAccountState,
      listener: (context, state) {
        canScan = !(state is LoadingAccountState);

        if (state is UnauthenticatedState && state.tokenAdded) {
          Navigator.of(context).pop();
          return; 
        }

        if (state is UnauthenticatedState && !state.tokenAdded && state.message != null) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CompanionAppBar(
          title: 'Scan your Qr Code',
          color: Colors.red,
        ),
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Taking too long? The app might not have permission to use the camera.',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  if (!canScan) {
                    return;
                  }

                  if (scanData != lastQrScanned) {
                    BlocProvider.of<AccountBloc>(context).add(AddTokenEvent(scanData));
                  }

                  lastQrScanned = scanData;
                });
              },
            ),
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is LoadingAccountState) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Checking Api Key...',
                            style: Theme.of(context).textTheme.headline2.copyWith(
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}