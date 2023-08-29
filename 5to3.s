               job  Convert five-digit number to an address
               ctl  6611
     x1        equ  089
     five      equ  205
     three     equ  210
               org  336
     zones     dcw  @2skb@
     adr       dcw  #5
     number    dcw  #5
     start     sw   three-2
               lca  &15999,number
     outer     mcw  number,adr    Number to convert
               b    conv          Convert it to an address
               mcw  adr,three
               mcs  number,five
               w
               s    &1000,number  Subtract 1000
               bm   two,number    q. done
               b    outer         no
     two       lca  &15999,number
     outer2    mcw  number,adr    Number to convert
               b    conv2         Convert it to an address
               mcw  adr,three
               mcs  number,five
               w
               s    &1000,number  Subtract 1000
               bm   fast,number   q. done
               b    outer2        no
     fast      lca  &15999,number
     outer3    mcw  number,adr    Number to convert
               b    conv3         Convert it to an address
               mcw  adr,three
               mcs  number,five
               w
               s    &1000,number  Subtract 1000
               bm   done,number   q. done
               b    outer3        no
     done      h    done
               ltorg*
     *
     * Smallest routine to convert the five-digit number in adr to
     * a three character address, in place.  Needs the digit part
     * of the last character of the address of ZONES to be nine.
     *
     conv      sbr  convx&3
               bav  *&1           turn off overflow
     loop      a    @96@,adr-3
               bav  loop
               mz   adr-4,adr
               mn   adr-3,*&4
               mz   zones-0,adr-2
     convx     b    0-0
               ltorg*
     *
     * One that works similarly, but uses X1 and doesn't need ZONES
     * to be at a particular location.  Saving and restoring X1
     * would make it bigger and slower.
     *
     conv2     sbr  conv2x&3
               sbr  x1,0
               bav  *&1           turn off overflow
     loop2     a    @96@,adr-3
               bav  loop2
               mz   adr-4,adr
               mn   adr-3,x1
               mz   zones-9&x1,adr-2
     conv2x    b    0-0
               ltorg*
     *
     * Fastest routine to convert the five-digit number in adr to
     * a three character address, in place.  Uses X1.  Would be
     * slower and 14 characters longer if it saved and restored x1.
     *
     conv3     sbr  conv3x&3
               mcw  adr-3,x1
               mcw  @0@
               mz   hzone-15&x1,adr-2
               mz   lzone-15&x1,adr
     conv3x    b    0-0
     hzone     dcw  @9zri9zri9zri9zri@
     lzone     dcw  @9999zzzzrrrriiii@
               end  start
