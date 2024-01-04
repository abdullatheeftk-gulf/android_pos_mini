part of 'thermal_cubit.dart';

@immutable
abstract class ThermalState {}

class ThermalInitial extends ThermalState {}

final class GetUsbAddressState extends ThermalState{
  final String usbAddress;
  final bool usbPrinterAvailable;

  GetUsbAddressState({required this.usbPrinterAvailable, required this.usbAddress});
}

final class ConnectedToUsbPrinterState extends ThermalState{
  final bool isConnected;

  ConnectedToUsbPrinterState({required this.isConnected});
}

final class PrintSuccessState extends ThermalState{
}

final class PrintFailedState extends ThermalState{
}
