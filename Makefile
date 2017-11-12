compile:
	rm -rf _build/
	jbuilder build main.exe

clean:
	ocamlbuild -clean

play:
	./_build/default/main.exe

test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte
