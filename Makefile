make-doc:
	joliedoc server.ol --internals

doc:
	xdg-open joliedoc/index.html

clean:
	rm -rf joliedoc


.PHONY: make-doc doc clean
