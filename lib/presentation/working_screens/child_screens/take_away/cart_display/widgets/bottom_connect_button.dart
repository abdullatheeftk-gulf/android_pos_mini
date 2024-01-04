import 'dart:io';

import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/blocs/thermal_printer/thermal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomConnectButton extends StatelessWidget {
  final Function generateInvoiceButtonClicked;
  final Function connectThermalPrinterClicked;

  const BottomConnectButton({
    super.key,
    required this.generateInvoiceButtonClicked,
    required this.connectThermalPrinterClicked,
  });

  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      final thermalCubit = context.read<ThermalCubit>();
      bool isThermalPrinterConnected = false;
      return BlocBuilder(
          bloc: thermalCubit,
          buildWhen: (prev,cur){
            if(cur is ConnectedToUsbPrinterState){
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is ConnectedToUsbPrinterState) {
              isThermalPrinterConnected = state.isConnected;
            }
            if (isThermalPrinterConnected) {
              return ElevatedButton(
                onPressed: () {
                  generateInvoiceButtonClicked();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 6,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue),
                child: const Text(
                  'Generate Invoice',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return ElevatedButton(
                onPressed: () {
                  context.read<MainBloc>().add(NavigateToMainScreenToConnectToThermalScreenEvent());
                },
                style: ElevatedButton.styleFrom(
                    elevation: 6,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red),
                child: const Text(
                  'Connect Thermal Printer',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          });
    } else {
      return ElevatedButton(
        onPressed: () {
          generateInvoiceButtonClicked();
        },
        style: ElevatedButton.styleFrom(
            elevation: 6,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue),
        child: const Text(
          'Generate Invoice',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }
}
