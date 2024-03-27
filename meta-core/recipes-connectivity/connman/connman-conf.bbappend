FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://wired.config"

do_install() {
    #Configure Wired network interface.
	sed -i 's%\(^IPv4\s*=\s*\)MY_IP_ADDRESS\(/.*/\)MY_GATEWAY_ADDRESS%\1${MY_IP_ADDRESS}\2${MY_GATEWAY_ADDRESS}%g' ${WORKDIR}/wired.config
	sed -i 's%\(^MAC\s*=\s*\)MY_MAC_ADDRESS%\1${MY_MAC_ADDRESS}%g' ${WORKDIR}/wired.config
	install -d ${D}${localstatedir}/lib/connman
 	install -m 0644 ${WORKDIR}/wired.config ${D}${localstatedir}/lib/connman
}
