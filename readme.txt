http://www.ioctls.net 

 

const  

 IOCTL_STORAGE_MEDIA_REMOVAL = $002D4804;  

 FSCTL_LOCK_VOLUME = $90018;  

FSCTL_UNLOCK_VOLUME = $9001C;  

var 

remove_prevent : boolean; 

 

DeviceIoControl( 

  hDevice,                                                        // handle to device 

  IOCTL_STORAGE_MEDIA_REMOVAL,      // dwIoControlCode 

  @remove_prevent,                                    // input buffer 

  sizeof(boolean),                                          // size of input buffer 

  nil,                                                                 // lpOutBuffer 

  0,                                                                   // nOutBufferSize 

  n,                                                                  // number of bytes returned 

  nil                                                                 // OVERLAPPED structure 

); 

 

 

dwIoControlCode = FSCTL_UNLOCK_VOLUME; // operation code 

lpInBuffer = NULL; // pointer to input buffer; not used; must be NULL 

nInBufferSize = 0; // size of input buffer; not used; must be zero 

lpOutBuffer ; // pointer to output buffer; not used; must be NULL 

nOutBufferSize ; // size of output buffer; not used; must be zero 

lpBytesReturned ; // pointer to DWORD used by DeviceIoControl function 

 

 

dwIoControlCode = FSCTL_LOCK_VOLUME; // operation code 

lpInBuffer = NULL; // pointer to input buffer; not used; must be NULL 

nInBufferSize = 0; // size of input buffer; not used; must be zero 

lpOutBuffer ; // pointer to output buffer; not used; must be NULL 

nOutBufferSize ; // size of output buffer; not used; must be zero 

lpBytesReturned ; // pointer to DWORD used by DeviceIoControl function 