## My precious

This is my `.emacs` and you might not like my choices. In which case, have
a look [here][16] or [here][5].

Besides several interface tweaks, my main concern was setting up Emacs to work
with Perl and Python code. Ymmv.

## Installation

    sudo pip install pyflakes pep8
    cd /tmp
    curl -L https://github.com/pfig/dotemacs/tarball/master | tar xf -

Copy the `.emacs` file and the `.emacs.d` directory to your home directory. If
you have something in your `.emacs` that you hold dear, merge it with mine.
Patches welcome.

After this, follow the instructions from Eliot on [how to install Ropemacs and
Flymake][13] (make sure you create `pycheckers`).

**NB:** the usual Python incantations for installing packages don't apply to
Pymacs (`pip install`, `easy_install`, or even `python setup.py install`), so
[download it separately][15] and run `make check && sudo make install`.

## Standing on the shoulders of giants, etc.

Very little of what's here is my doing, I've mostly harvested bits and pieces
from here and there to get to this. I am very grateful for all the hard work of
everyone in the following list, and apologise in advance to those I forget to
mention (but do drop me a note if you want):

* Everyone contributing to the [Emacs wiki][0],
* The [Aquamacs][1] team,
* Issac Trotts for [Nav][2],
* Ethan Schoonover for [Solarized][3] and Gref Pfeil for the [Emacs port][4],
* Tomohiro Matsuyama for his [Auto Complete mode][6],
* Jeremiah Dodds and all the previous developers of [markdown-mode][8], in
  particular Jason Blevins,
* Sergei Matusevich for the [Pig support][9],
* François Pinard for his ELisp-Python bridge, [Pymacs][10],
* Dino Chiesa and Donald Curtis for [flymake-cursor][7],
* Ali Rudi for [Ropemacs][14],
* João Távora, the autor of [yasnippet][11], a great template system for Emacs,
* Eliot from [SaltyCrane][12] for his tremendous post on [setting up Emacs to
  work with Python][13],


[0]: http://www.emacswiki.org/ "The Emacs Wiki"
[1]: http://aquamacs.org/ "Emacs for OS X"
[2]: http://code.google.com/p/emacs-nav/ "Tree browser for Emacs"
[3]: http://ethanschoonover.com/solarized "Solarized colour schemes"
[4]: https://github.com/sellout/emacs-color-theme-solarized "Solarized for Emacs"
[5]: http://dotfiles.org/.emacs ".emacs files at dotfiles.org"
[6]: http://cx4a.org/software/auto-complete/ "Auto Complete mode"
[7]: http://www.emacswiki.org/emacs/flymake-cursor.el "On-the-fly syntax checker"
[8]: http://jblevins.org/projects/markdown-mode/ "Markdown on Emacs"
[9]: https://github.com/motus/pig-mode "Emacs rides a pig"
[10]: http://pymacs.progiciels-bpi.ca/index.html "... and a snake"
[11]: https://github.com/capitaomorte/yasnippet "Snippets on Emacs"
[12]: http://www.saltycrane.com/ "Eliot's site"
[13]: http://www.saltycrane.com/blog/2010/05/my-emacs-python-environment/ "Emacs and Python"
[14]: http://rope.sourceforge.net/ "Python refactoring"
[15]: https://github.com/pinard/Pymacs/tags "Pymacs download"
[16]: http://www.dotemacs.de/ "The mother of all dotemacs files"
