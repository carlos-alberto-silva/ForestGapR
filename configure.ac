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
  "branches": {
    "only": [
      "master",
      "/^v[\\d\\.]*$/"
    ]
  },
  "before_deploy": [
    "export PKGVERSION=$(sed -n '/^Version:/s/Version: \\(.*\\)/\\1/p' DESCRIPTION)",
    "echo \"Upload file glob is $(echo $PKGNAME)_${PKGVERSION}*\""
  ],
  "deploy": [
    {
      "provider": "releases",
      "file_glob": true,
      "file": [
        "${PKGNAME}_${PKGVERSION}_${TRAVIS_OS_NAME}*"
      ],
      "overwrite": true,
      "cleanup": true,
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
        "arch": "amd64",
        "dist": "focal",
        "env": [
          {
            "BADGE": "linux"
          }
        ],
        "cache": {
          "ccache": true,
          "packages": true
        }
      },
      {
        "r": "release",
        "os": "osx",
        "env": [
          {
            "BADGE": "osx"
          }
        ],
        "cache": {
          "ccache": true,
          "packages": true
        }
      },
      {
        "os": "windows",
        "env": [
          {
            "BADGE": "windows"
          }
        ],
        "language": "shell"
      }
    ]
  }
}