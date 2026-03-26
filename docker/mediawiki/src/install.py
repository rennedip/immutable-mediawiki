import os
import yaml
from git import Repo

config = {}
script_path = os.path.realpath(__file__)
script_directory_path = os.path.dirname(script_path)
mediawiki_directory_path = os.path.join(script_directory_path, "mediawiki")

with open("config.yaml", "r") as file:
    config = yaml.safe_load(file)

mediawiki_repo = Repo.clone_from(config["repo"], mediawiki_directory_path)

for extensionName, extension in config["extensions"].items():
    extension_path = os.path.join(mediawiki_directory_path, extension["dest"])

    extension_repo = Repo.clone_from(extension["repo"], extension_path)