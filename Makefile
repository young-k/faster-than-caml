compile:
	ocamlbuild 
	jbuilder build main.exe

clean:
	ocamlbuild -clean

play:
	./_build/default/main.exe

test:
	ocamlbuild -use-ocamlfind test_main.byte && ./test_main.byte
