BUILD = build
WSLIB = ../wslib
WSLIB_BUILD = $(WSLIB)/build
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile

WSF = $(patsubst ./%,%,$(shell find . -type f -name '*.wsf'))
WS = $(patsubst %.wsf,$(BUILD)/%.ws,$(WSF))

.PHONY: all
all: $(WS) $(BUILD)/euler/14

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

.PRECIOUS: $(BUILD)/%.wsa
$(BUILD)/%.wsa: %.wsf $(WSLIB)/wsf.sed
	@mkdir -p $(@D)
	$(SED) -Ef $(WSLIB)/wsf.sed $< > $@
	@cat $@ $(filter %.wsa,$^) | sponge $@

$(BUILD)/euler/1.wsa: $(WSLIB_BUILD)/math/math.wsa
$(BUILD)/euler/6.wsa: $(WSLIB_BUILD)/math/math.wsa
$(BUILD)/euler/16.wsa: $(WSLIB_BUILD)/math/exp.wsa
$(BUILD)/euler/48.wsa: $(WSLIB_BUILD)/math/exp.wsa

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

$(WSLIB)/%:
	$(error No wslib installation found at WSLIB=$(WSLIB))
$(WSLIB)/build/%.wsa:
	@$(MAKE) -C $(WSLIB) --no-print-directory $(@:$(WSLIB)/%=%)

.PHONY: clean clean_all
clean:
	@rm -rf $(BUILD)/
clean_all: clean
	@$(MAKE) -C $(WSLIB) --no-print-directory clean
