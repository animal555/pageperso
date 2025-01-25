HS := adt.hs conditionals.hs higherorder.hs ioExamples.hs listComprehension.hs monadsAndLaziness.hs probabilityMonadExample.hs taster.hs types.hs
MD := index.md

HTML := $(HS:.hs=.html) $(MD:.md=.html)



all: $(HTML)

%.html : %.hs
	./htmlify.sh $< > $@

%.html : %.md
	pandoc -s --css ../static/style.css --template=htmltemplate.html -f markdown $< > $@
