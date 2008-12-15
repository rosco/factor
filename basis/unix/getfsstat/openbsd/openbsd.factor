! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.syntax ;
IN: unix.getfsstat.openbsd

: MNT_WAIT        1       ; ! synchronously wait for I/O to complete
: MNT_NOWAIT      2       ; ! start all I/O, but do not wait for it
: MNT_LAZY        3       ; ! push data not written by filesystem syncer

FUNCTION: int getfsstat ( statfs* buf, int bufsize, int flags ) ;