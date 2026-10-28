# Intune Attributes modifiers
Powershell script per modificare extensionAttributes di una o piu' macchine Intune/EntraID.

Permette di modificare vari extension Attributes di macchine Intune tramite cli tool `Mg.Graph`.

## Getting started

Prende path ad un CSV con struttura:

```
       searchName,  extensionAttribute1,  extensionAttribute2,  extensionAttribute3,  extensionAttribute4,  extensionAttribute5
     CIBIO-TEST-1,                xxxxx,                xxxxx,                xxxxx,                xxxxx,                xxxxx
     CIBIO-TEST-2,                xxxxx,                xxxxx,                xxxxx,                xxxxx,                xxxxx
```

Cerca per `$searchName` macchina su `Mg.Graph` e aggiorna dispositivo con gli attributi specificati

>[!Warning]
> extensionAttribute* se assente viene RIMOSSO dal device.

## Usage
Aprire PowerShell come amministratore (run as administrator), raggiungere posizione script e digitare il seguente comando:

```
    .\Update-EntraDevices.ps1 -CsvPath "C:\percorso\dispositivi.csv"
```
