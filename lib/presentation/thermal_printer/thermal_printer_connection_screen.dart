import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/repositories/thermal_printer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

class ThermalPrinterConnectionScreen extends StatefulWidget {
  const ThermalPrinterConnectionScreen({super.key});

  @override
  State<ThermalPrinterConnectionScreen> createState() =>
      _ThermalPrinterConnectionScreenState();
}

class _ThermalPrinterConnectionScreenState
    extends State<ThermalPrinterConnectionScreen> {
  @override
  void initState() {
    context.read<MainBloc>().add(ScanForAvailableThermalPrintersEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thermal Printer"),
      ),
      body: BlocBuilder<MainBloc, MainState>(
        buildWhen: (prev, cur) {
          if (cur is ThermalUiBuildState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          USBStatus usbStatus = USBStatus.none;
          List<MyPrintDevice> myPrintDevices = [];
          String connectionStatus = "";
          switch (state.runtimeType) {
            case ThermalPrinterUsbConnectionState:
              {
                usbStatus =
                    (state as ThermalPrinterUsbConnectionState).usbStatus;
                break;
              }
            case ThermalPrinterAvailablePrinterState:
              {
                myPrintDevices =
                    (state as ThermalPrinterAvailablePrinterState).devices;
                break;
              }
            case ThermalPrintConnectionStatus:{
              connectionStatus = (state as ThermalPrintConnectionStatus).connectionStatus;
              break;
            }
            default:
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(usbStatus.name),
                myPrintDevices.isEmpty
                    ? const Text("Printers are not available")
                    : Text(
                        "name = ${myPrintDevices[0].deviceName}"),
                myPrintDevices.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().add(ConnectToThermalPrinterEvent(device: myPrintDevices[0]));
                        },
                        child:  Text("Connect $connectionStatus"),
                      )
                    : const SizedBox(),
                connectionStatus.isNotEmpty ?  Text(connectionStatus,style: const  TextStyle(color: Colors.green),):const SizedBox(),
                connectionStatus == "Connected" ? ElevatedButton(onPressed: (){
                  context.read<MainBloc>().add(TestThermalPrintEvent());
                }, child: const Text('Test Print'),) :const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}
