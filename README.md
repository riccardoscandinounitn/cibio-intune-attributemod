# cibio-intune-attributemod
Powershell script to modify Intune attributets of multiple devices.
[NOTA] VibeCodato piu' modifiche manuali.

## I/O Description

[INPUT] Prende path ad un CSV con struttura:

>        searchName,         displayName,  extensionAttribute1,  extensionAttribute2,  extensionAttribute3,  extensionAttribute4,
>      CIBIO-TEST-1,  CIBIO-LABMGMT-PROV,          40000003647,                CIBIO,                     ,            cibiotest,
>      CIBIO-TEMP-2,  CIBIO-LABMGMT-SONN,          40000002448,                CIBIO,                     ,                     ,
> CIBIO-LABMGMT-ARR,                    ,          40000004208,                CIBIO,                     ,                     ,
> etc.

[OUTPUT] Cerca per $searchName macchina su Mg.Graph e aggiorna dispositivo con gli attributi specificati
>[!Warning]
> extensionAttribute* se assente viene RIMOSSO dal device.

## Usage
Aprire PowerShell come amministratore (run as administrator), raggiungere posizione file corrente
            e digitare il seguente comando:

    ```
    .\Update-EntraDevices.ps1 -CsvPath "C:\percorso\dispositivi.csv"
    ```
