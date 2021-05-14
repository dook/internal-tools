#!/bin/sh
BASE_RESOURCE_PATH=./.my-work-resources/
PROJECT_PYTHON_ENV_NAME=my-work-venv
LINES_MODIFIED_PATH=${BASE_RESOURCE_PATH}collect_lines_modified.py
REPORT_GENERATE_PATH=${BASE_RESOURCE_PATH}generate_report.py
CONFIG_FILE_PATH=${BASE_RESOURCE_PATH}.config
REPORT_MULTI_LINE_PROJECT_ARRAY=()

is_git_repo() {
    [[ -d .git ]] || git -C ${1} rev-parse --git-dir > /dev/null 2>&1
}

check_if_python_virtual_env_exits() {
    [[ -f "${BASE_RESOURCE_PATH}${PROJECT_PYTHON_ENV_NAME}" ]]
}

create_python_virtual_env() {
    python3 -m venv ${BASE_RESOURCE_PATH}${PROJECT_PYTHON_ENV_NAME}
}

check_if_weasyprint_installed() {
    pip list --disable-pip-version-check | grep -c WeasyPrint
}

check_if_jinja2_installed() {
    pip list --disable-pip-version-check | grep -c Jinja2
}


if ! [[ -f "$CONFIG_FILE_PATH" ]]; then
    read -p "Imię i nazwisko: " name surname
    name_and_surname="${name} ${surname}"
    if ! [[ -z "$name_and_surname" ]]; then
        touch "${CONFIG_FILE_PATH}"
        echo "name_and_surname='${name_and_surname}'" > "${CONFIG_FILE_PATH}"
    fi; else
        . ${CONFIG_FILE_PATH}
fi

if [[ -z "$name_and_surname" ]]; then
    echo "Konieczne poprawne wprowadzenie: Imię i nazwisko"
fi

defdate=`date "+%Y-%m"`

read -p "Data logu rrrr-mm [${defdate}]: " date </dev/tty

if [[ -z "$date" ]]; then
  date=${defdate}
fi

if [[ -z "$gituser" ]]; then
    defgituser=`git config user.email`
    read -p "Email użytkownika git: [${defgituser}]: " gituser </dev/tty

    if [[ -z "$gituser" ]]; then
      gituser=${defgituser}
    fi

    echo "gituser='${gituser}'" >> "${CONFIG_FILE_PATH}"
fi

mkdir -p my-work-reports

if is_git_repo .; then
    echo "'my-work.sh' should run in top directory"
    exit 1
fi

if ! check_if_python_virtual_env_exits; then
    create_python_virtual_env
fi

source ${BASE_RESOURCE_PATH}${PROJECT_PYTHON_ENV_NAME}/bin/activate

if [[ "$(check_if_weasyprint_installed)" -lt 1  || "$(check_if_jinja2_installed)" -lt 1 ]]; then
    pip install weasyprint
    pip install Jinja2
fi

for f in *; do
    if [[ -d "$f" ]]; then
        if is_git_repo "./$f"; then
            REPORT_MULTI_LINE_PROJECT_ARRAY+="$(python ${LINES_MODIFIED_PATH} "$f" "$date" "$gituser")"
        fi
    fi
done

python ${REPORT_GENERATE_PATH} "${name_and_surname}" "${date}" "${REPORT_MULTI_LINE_PROJECT_ARRAY[0]}"
