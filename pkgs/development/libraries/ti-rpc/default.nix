{ fetchurl, stdenv, krb5 }:

stdenv.mkDerivation rec {
  name = "libtirpc-0.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/libtirpc/${name}.tar.bz2";
    sha256 = "07d1wlfzf3ia09mjn3f3ay8isk7yx4a6ckfkzx5khnqlc7amkzna";
  };

  propagatedBuildInputs = [ krb5 ];

  # http://www.sourcemage.org/projects/grimoire/repository/revisions/d6344b6a3a94b88ed67925a474de5930803acfbf
  preConfigure = ''
    echo "" > src/des_crypt.c

    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  preInstall = "mkdir -p $out/etc";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "http://sourceforge.net/projects/libtirpc/";
    description = "The transport-independent Sun RPC implementation (TI-RPC)";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
       Currently, NFS commands use the SunRPC routines provided by the
       glibc.  These routines do not support IPv6 addresses.  Ulrich
       Drepper, who is the maintainer of the glibc, refuses any change in
       the glibc concerning the RPC.  He wants the RPC to become a separate
       library.  Other OS (NetBSD, FreeBSD, Solarix, HP-UX, AIX) have
       migrated their SunRPC library to a TI-RPC (Transport Independent
       RPC) implementation.  This implementation allows the support of
       other transports than UDP and TCP over IPv4.  FreeBSD provides a
       TI-RPC library ported from NetBSD with improvements.  This library
       already supports IPv6.  So, the FreeBSD release 5.2.1 TI-RPC has
       been ported to replace the SunRPC of the glibc.
    '';
  };
}
