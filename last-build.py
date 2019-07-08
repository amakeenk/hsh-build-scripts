#!/usr/bin/python3

import feedparser
import sh
import sys


def args_check():
    if len(sys.argv) < 2:
        usage()
    elif len(sys.argv) == 3:
        if sys.argv[2] != "--clone":
            usage()


def usage():
    print("Usage: last-build <package> [--clone]")
    sys.exit(1)


def get_last_build_source(package):
    gearsurl = "http://git.altlinux.org/gears/{0}/{1}.git?p={1}.git;a=rss".format(package[0], package)
    gears = feedparser.parse("http://git.altlinux.org/gears/{0}/{1}.git?p={1}.git;a=rss".format(package[0], package))
    srpms = feedparser.parse("http://git.altlinux.org/srpms/{0}/{1}.git?p={1}.git;a=rss".format(package[0], package))
    if not "updated_parsed" in gears["feed"]:
        if "updated_parsed" in srpms["feed"]:
            return "srpms"
    else:
        if not "updated_parsed" in srpms["feed"]:
            return "gears"
    try:
        if gears["feed"]["updated_parsed"] < srpms["feed"]["updated_parsed"]:
            return "srpms"
        else:
            return "gears"
    except:
        print("Some error occured!")
        sys.exit(1)


def clone_repo(repo_url):
    print("Try clone repo...")
    sh.git.clone(repo_url)


if __name__ == "__main__":
    args_check()
    package_name = sys.argv[1]
    last_build_soure = get_last_build_source(package_name)
    last_build_source_url = "http://git.altlinux.org/{}/{}/{}.git".format(last_build_soure, package_name[0], package_name)
    print("Last build source for package {} is {}".format(package_name, last_build_soure))
    print("Repo url: {}".format(last_build_source_url))
    if len(sys.argv) == 3:
        clone_repo(last_build_source_url)
