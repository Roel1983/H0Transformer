# Targets
PARTS                    = TransformerHouse
PARTS                   += Cradle
IMAGES                   = H0Transformer

# Folders
DEPDIR                  ?= ./.deps
PARTSDIR                ?= ./parts
IMAGESDIR               ?= ./images

# Applications
OPENSCAD                ?= openscad

# Derived
stl_files = $(PARTS:%=$(PARTSDIR)/%.stl)
png_files = $(IMAGES:%=$(IMAGESDIR)/%.png)


.PHONY: all all_stl all_png
all: all_stl all_png
all_stl: $(stl_files)
all_png: $(png_files)

$(PARTSDIR)/%.stl: %.scad
$(PARTSDIR)/%.stl: %.scad $(DEPDIR)/%.d | $(DEPDIR) $(PARTSDIR)
	$(OPENSCAD) -d $(DEPDIR)/$*.d -o $(PARTSDIR)/$*.stl $*.scad

$(IMAGESDIR)/%.png: %.scad
$(IMAGESDIR)/%.png: %.scad $(DEPDIR)/%.d | $(DEPDIR) $(IMAGESDIR)   # $(DEPDIR)/%.d | $(DEPDIR) $(IMAGESDIR)
	$(OPENSCAD) -d $(DEPDIR)/$*.d -D "MAKE_PNG=1" -o $(IMAGESDIR)/$*.png $*.scad

$(DEPDIR) $(PARTSDIR) $(IMAGESDIR): ; @mkdir -p $@

DEPFILES := $(PARTS:%=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))

