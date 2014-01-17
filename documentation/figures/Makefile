SVG=$(wildcard *.svg)
PDF=$(SVG:.svg=.pdf)

.PHONY: all
all: $(PDF) acq_fsm.pdf

%.pdf : %.svg
	inkscape --without-gui $< -A $@

clean:
	rm -f $(PDF)
	rm -f acq_fsm.pdf

show:
	$(info all svg: $(SVG))
	$(info all pdf: $(PDF))

acq_fsm.pdf: acq_fsm.dia
	dia -e acq_fsm.pdf acq_fsm.dia
	# crop around front panel
	#   bbox origin is in bottom left corner of the page
	#   bbox unit is [points]
	pdfcrop --bbox '50 550 550 780' acq_fsm.pdf acq_fsm.pdf

