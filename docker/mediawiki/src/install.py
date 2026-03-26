import os
import yaml
from git import Repo

config = {}
build_dir_path = os.environ.get("BUILD_DIR")
config_path = os.path.join(build_dir_path, "config.yaml")
mediawiki_dir_path = os.environ.get("MEDIAWIKI_DIR")

with open(config_path, "r") as file:
    config = yaml.safe_load(file)

mediawiki_repo = Repo.clone_from(
    url=config["repo"], 
    to_path=mediawiki_dir_path,
    multi_options=[
        f"--depth 1",
        f"--branch {config["version"]}"
    ]
)

for extensionName, extension in config["extensions"].items():
    extension_path = os.path.join(mediawiki_dir_path, extension["dest"])

    extension_repo = Repo.clone_from(
        url=extension["repo"],
        to_path=extension_path,
        multi_options=[
            f"--depth 1",
            f"--branch {extension["version"]}"
        ]
    )