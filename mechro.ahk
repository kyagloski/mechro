;
; AUDIO DEVICE SWITCHER CODE
;

Devices := {}
IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+3*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
ObjRelease(IMMDeviceEnumerator)

DllCall(NumGet(NumGet(IMMDeviceCollection+0)+3*A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
Loop % (Count)
{
    DllCall(NumGet(NumGet(IMMDeviceCollection+0)+4*A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index-1, "UPtrP", IMMDevice, "UInt")

    DllCall(NumGet(NumGet(IMMDevice+0)+5*A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
    DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

    DllCall(NumGet(NumGet(IMMDevice+0)+4*A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
    ObjRelease(IMMDevice)

    VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
    VarSetCapacity(PROPERTYKEY, 20)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)
    NumPut(14, &PROPERTYKEY + 16, "UInt")
    DllCall(NumGet(NumGet(IPropertyStore+0)+5*A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")
    DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
    DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
    ObjRelease(IPropertyStore)

    ObjRawSet(Devices, DeviceName, DeviceID)
}
ObjRelease(IMMDeviceCollection)
Return

SetDefaultEndpoint(DeviceID)
{
    IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")
    DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")
    ObjRelease(IPolicyConfig)
}

GetDeviceID(Devices, Name)
{
    For DeviceName, DeviceID in Devices
        If (InStr(DeviceName, Name))
            Return DeviceID
}

DeviceIndex := 0

GetNextDeviceID()
{
    global DeviceIndex
    global Devices
    ald := []
    For DeviceName, DeviceID in Devices
        ald.Push(DeviceName)

    DeviceIndex++
    if (DeviceIndex > ObjMaxIndex(ald))
        DeviceIndex := 1   

    return SetDefaultEndpoint( GetDeviceID(Devices, ald[DeviceIndex]) )
}

;
; KEY MAPPING CODE
;

<!<^Z:: SetDefaultEndpoint( GetNextDeviceID() )
^,::Send   {Media_Prev}
^/::Send   {Media_Play_Pause}
^.::Send  {Media_Next}
^Up::SoundSet, +2
^Down::SoundSet, -2

;
; IBM MODEL M WIN KEY REMAPPING CODE
;

; logout: ctrl + alt + L
<^<!l::
Run, rundll32.exe user32.dll`, LockWorkStation
return

; win key: alt + space
<!Space::
Keywait, LAlt
Keywait, Space
Send {LWin}
return

; win arrow controls: ctrl + alt + arrow
<^<!Up::
    SendInput, #{Up}
return

<^<!Down::
    SendInput, #{Down}
return

<^<!Left::
    SendInput, #{Left}
return

<^<!Right::
    SendInput, #{Right}
return


