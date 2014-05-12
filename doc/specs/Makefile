# Makefile for Latex work

TEXFILE = adc100m14b4cha.tex
DIAGRAM = block_diagram.dia
S_MACHINE = state_machine.dia

.PHONY: clean view

$(TEXFILE:.tex=.pdf): $(TEXFILE) $(DIAGRAM:.dia=.pdf) $(S_MACHINE:.dia=.pdf)
	pdflatex $(TEXFILE)
# Not very nice hack to get references right
	pdflatex $(TEXFILE)

$(DIAGRAM:.dia=.pdf): $(DIAGRAM:.dia=.eps)
	epstopdf $(DIAGRAM:.dia=.eps)

$(DIAGRAM:.dia=.eps): $(DIAGRAM)
	dia -e $(DIAGRAM:.dia=.eps) $(DIAGRAM)

$(S_MACHINE:.dia=.pdf): $(S_MACHINE:.dia=.eps)
	epstopdf $(S_MACHINE:.dia=.eps)

$(S_MACHINE:.dia=.eps): $(S_MACHINE)
	dia -e $(S_MACHINE:.dia=.eps) $(S_MACHINE)

view: $(TEXFILE:.tex=.pdf)
	evince $(TEXFILE:.tex=.pdf)

clean:
	@rm -f \
	$(TEXFILE:.tex=.aux) \
	$(TEXFILE:.tex=.log) \
	$(TEXFILE:.tex=.out) \
	$(TEXFILE:.tex=.toc) \
	$(TEXFILE:.tex=.pdf) \
	$(DIAGRAM:.dia=.pdf) \
	$(DIAGRAM:.dia=.eps) \
	$(S_MACHINE:.dia=.pdf) \
	$(S_MACHINE:.dia=.eps)