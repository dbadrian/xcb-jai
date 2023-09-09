
#scope_file
X11 :: #import "X11";

libX11_xcb :: #system_library "libX11-xcb";
#scope_export

// manually defined since the default jai X11 module doesn't know about it
XGetXCBConnection :: (display: *X11.Display) -> *xcb_connection_t #foreign libX11_xcb;

// just for convenience
crt :: #system_library "libc";
xcb_free :: (memory: *void) #foreign crt "free";

#if OS == .LINUX {
    #load "generated_linux.jai";
    libusb :: #system_library "libxcb";
} else {
    // only linux!
    assert(false);
}


