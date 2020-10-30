{
  "language": "r",
  "os": [
    "linux"
  ],
  "dist": "xenial",
  "env": {
    "global": [
      {
        "PKGNAME": "ForestGapR"
      }
    ]
  },
  "script": [
    "R CMD build .",
    "travis_wait 30 R CMD check *tar.gz --as-cran",
    "R CMD INSTALL . --build"
  ],
  "after_script": [
    "cat ${PKGNAME}.Rcheck/00check.log",
    "cat ${PKGNAME}.Rcheck/00install.out"
  ],
  "deploy": [
    {
      "provider": "releases",
      "file_glob": true,
      "file": [
        "${PKGNAME}_${PKGVERSION}_${TRAVIS_OS_NAME}*"
      ],
      "overwrite": true,
      "skip_cleanup": true,
      "on": {
        "repo": "carlos-alberto-silva/ForestGapR",
        "tags": true
      }
    }
  ],
  "jobs": {
    "include": [
      {
        "r": "release",
        "os": "linux",
        "env": [
          {
            "BADGE": "linux"
          }
        ],
        "cache": {
          "ccache": true,
          "packages": true
        }
      }
    ]
  }
}