import 'package:android_pos_mini/blocs/thermal_printer/thermal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectThermalPrinterScreen extends StatelessWidget {
  const ConnectThermalPrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final thermalCubit = context.read<ThermalCubit>();

    bool usbPrinterAvailable = false;
    String? usbName;
    bool isUsbPrinterConnected = false;

    return BlocConsumer<ThermalCubit, ThermalState>(
      bloc: thermalCubit,
      listener: (context, state) {
        if (state is PrintSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Printed")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Print Failed")));
        }
      },
      listenWhen: (prev, cur) {
        if (cur is PrintSuccessState || cur is PrintFailedState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur is GetUsbAddressState || cur is ConnectedToUsbPrinterState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is GetUsbAddressState) {
          usbPrinterAvailable = state.usbPrinterAvailable;
          usbName = state.usbAddress;
        }
        if (state is ConnectedToUsbPrinterState) {
          isUsbPrinterConnected = state.isConnected;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Connect Thermal Printer"),
            backgroundColor: isUsbPrinterConnected ? Colors.blue : Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                usbPrinterAvailable
                    ? isUsbPrinterConnected
                        ? const SizedBox()
                        : Text(
                            usbName ?? "Printer is not available",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                            ),
                          )
                    : const Text(
                        "Printer is not available",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),

                // Refresh button to search available device

                usbPrinterAvailable || isUsbPrinterConnected
                    ? const SizedBox()
                    : ElevatedButton(
                        onPressed: () {
                          // search for available device
                          thermalCubit.getUsbAddress();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Text("Refresh"), Icon(Icons.refresh)],
                        ),
                      ),
                // if thermal printer available and thermal printer not connected
                usbPrinterAvailable && !isUsbPrinterConnected
                    ? ElevatedButton(
                        onPressed: () {
                          thermalCubit.connectUsbPrinter();
                        },
                        child: const Text("Connect to Thermal Printer"),
                      )
                    : const SizedBox(),
                // Show connected
                isUsbPrinterConnected
                    ? const Text(
                        "Connected",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.cyan,
                        ),
                      )
                    : const SizedBox(),
                // Testing Printer
                isUsbPrinterConnected
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              thermalCubit.doTestPrintInText();
                            },
                            child: const Text("Test 1"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              thermalCubit
                                  .doTestPrintArabicText("أنا مهندس كهربائي");
                            },
                            child: const Text("Arabic"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              thermalCubit.doTestFullEscPosTicket();
                            },
                            child: const Text("Test Ticket"),
                          ),
                        ],
                      )
                    : const SizedBox(),
                isUsbPrinterConnected
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Back"),
                            ],
                          ),
                        ),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
