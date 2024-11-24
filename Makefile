MD := index.md projectsForStudents.md
HTML := $(MD:.md=.html)

all: $(HTML)

%.html : %.md
	pandoc -s --css static/style.css --template=htmltemplate.html -f markdown $< > $@
