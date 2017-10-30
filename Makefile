test:
	ocamlbuild -use-ocamlfind test_main.byte && ./test_main.byte

compile:
	ocamlbuild 

clean:
	ocamlbuild -clean
