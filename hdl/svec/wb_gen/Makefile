WBGEN2=~/projects/wbgen2/wbgen2
RTL=../rtl/
TEX=../../../documentation/manuals/gateware/svec/

carrier_csr:
	$(WBGEN2) -l vhdl -V $(RTL)$@.vhd -f html -D $@.htm -C $@.h $@.wb
	$(WBGEN2) -f texinfo -D $(TEX)$@.tex $@.wb
