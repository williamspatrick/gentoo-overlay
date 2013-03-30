# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm multilib

DESCRIPTION="Brother MFC 7440N LPR+cupswrapper driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public/us/us_ot/en/dlf/download_top.html?reg=us&c=us_ot&lang=en&prod=mfc7440n_all&SRC="
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/brmfc7440nlpr-2.0.2-1.i386.rpm
		 http://www.brother.com/pub/bsc/linux/dlf/cupswrapperMFC7440N-2.0.2-1.i386.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	has_multilib_profile && ABI=x86
	cp -r usr "${D}" || die
	cp -r var "${D}" || die

	einfo "/usr/local/Brother/inf/braddprinter -i MFC7440N"
	einfo "bash /usr/local/Brother/cupswrapper/cupswrapperMFC7440N-2.0.2 -i"
}

pkg_postinst() {
	/usr/local/Brother/inf/setupPrintcap MFC7440N -i USB
	/usr/local/Brother/inf/braddprinter -i MFC7440N
	/usr/local/Brother/cupswrapper/cupswrapperMFC7440N-2.0.2 -i

	ln -s /usr/lib/cups/filter/brlpdwrapperMFC7440N \
	      /usr/libexec/cups/filter/brlpdwrapperMFC7440N
}

pkg_prerm() {
	rm /usr/libexec/cups/filter/brlpdwrapperMFC7440N

	/usr/local/Brother/inf/setupPrintcap MFC7440N -e USB
	/usr/local/Brother/inf/braddprinter -e MFC7440N
	/usr/local/Brother/cupswrapper/cupswrapperMFC7440N-2.0.2 -e

	rm -fR /var/spool/lpd/MFC7440N/*
}


