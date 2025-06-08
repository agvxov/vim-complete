bundle: clean
	-mkdir -p object/.vim/
	cp -r autoload/ object/.vim/
	tar -C object/ -c .vim/ -f complete.tar

install: bundle
	tar -x -f complete.tar --dereference -C ~/

clean:
	-rm -frfr object/
	-rm -frfr complete.tar
