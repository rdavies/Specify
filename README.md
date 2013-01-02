Behave
======

Behave was developed out of a personal need for a simple yet powerful BDD library. I wanted something less than [Kiwi] and [Cedar], but didn't want to use the [Specta] and [Expecta] combination as I prefer the `should` terminology over `expect`.

Behave is built on top of OCUnit, allowing tests to be run from Xcode. It has optional dependencies on two sub-libraries: [Posit] provides expectations, and [Mockingbird] provides mocking and stubbing. These can be substituted for any other expectation or mocking library, such as [Expecta] or [OCMock].

See the [Wiki] for more information.

License
=======

This project is available under the MIT license. See the [LICENSE] file for details.

[Posit]: https://github.com/rdavies/Posit
[Mockingbird]: https://github.com/rdavies/Mockingbird
[Kiwi]: https://github.com/allending/Kiwi
[Cedar]: https://github.com/pivotal/cedar
[Specta]: https://github.com/petejkim/specta
[Expecta]: https://github.com/petejkim/expecta
[OCMock]: http://www.sente.ch/software/ocunit
[Wiki]: https://github.com/rdavies/Behave/wiki
[LICENSE]: https://github.com/rdavies/Behave/blob/master/LICENSE
