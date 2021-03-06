! Copyright (C) 2005, 2006 Eduardo Cavazos and Slava Pestov
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel math math.bitwise math.vectors
namespaces sequences x11 x11.xlib x11.constants x11.glx arrays
fry classes.struct ;
IN: x11.windows

: create-window-mask ( -- n )
    { CWBackPixel CWBorderPixel CWColormap CWEventMask } flags ;

: create-colormap ( visinfo -- colormap )
    [ dpy get root get ] dip visual>> AllocNone
    XCreateColormap ;

: event-mask ( -- n )
    {
        ExposureMask
        StructureNotifyMask
        KeyPressMask
        KeyReleaseMask
        ButtonPressMask
        ButtonReleaseMask
        PointerMotionMask
        FocusChangeMask
        EnterWindowMask
        LeaveWindowMask
        PropertyChangeMask
    } flags ;

: window-attributes ( visinfo -- attributes )
    XSetWindowAttributes <struct>
    0 >>background_pixel
    0 >>border_pixel
    event-mask >>event_mask
    swap create-colormap >>colormap ;

: set-size-hints ( window -- )
    XSizeHints <struct>
    USPosition >>flags
    [ dpy get ] 2dip XSetWMNormalHints ;

: auto-position ( window loc -- )
    { 0 0 } = [ drop ] [ set-size-hints ] if ;

: >xy ( pair -- x y ) first2 [ >integer ] bi@ ;

: create-window ( loc dim visinfo -- window )
    pick [
        [ [ [ dpy get root get ] dip >xy ] dip { 1 1 } vmax >xy 0 ] dip
        [ depth>> InputOutput ] keep
        [ visual>> create-window-mask ] keep
        window-attributes XCreateWindow
        dup
    ] dip auto-position ;

: glx-window ( loc dim visual -- window glx )
    [ create-window ] [ create-glx ] bi ;

: create-pixmap ( dim visual -- pixmap )
    [ [ { 0 0 } swap ] dip create-window ] [
        drop [ dpy get ] 2dip first2 24 XCreatePixmap
        [ "Failed to create offscreen pixmap" throw ] unless*
    ] 2bi ;

: (create-glx-pixmap) ( pixmap visual -- pixmap glx-pixmap )
    [ drop ] [
        [ dpy get ] 2dip swap glXCreateGLXPixmap
        [ "Failed to create offscreen GLXPixmap" throw ] unless*
    ] 2bi ;

: create-glx-pixmap ( dim visual -- pixmap glx-pixmap )
    [ create-pixmap ] [ (create-glx-pixmap) ] bi ;

: glx-pixmap ( dim visual -- glx pixmap glx-pixmap )
    [ nip create-glx ] [ create-glx-pixmap ] 2bi ;

: destroy-window ( win -- )
    dpy get swap XDestroyWindow drop ;

: set-closable ( win -- )
    dpy get swap "WM_DELETE_WINDOW" x-atom <Atom> 1
    XSetWMProtocols drop ;

: map-window ( win -- ) dpy get swap XMapWindow drop ;

: unmap-window ( win -- ) dpy get swap XUnmapWindow drop ;

: pixmap-bits ( dim pixmap -- alien )
    swap first2 '[ dpy get _ 0 0 _ _ AllPlanes ZPixmap XGetImage ] call
    [ XImage-pixels ] [ XDestroyImage drop ] bi ;
