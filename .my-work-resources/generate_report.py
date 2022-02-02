import sys
from pathlib import Path

from weasyprint import HTML, CSS
from ast import literal_eval
from jinja2 import Environment, FileSystemLoader


current_directory = Path(__file__).parent

env = Environment(loader=FileSystemLoader(current_directory))


def render_template(_name_and_surname, _report_date, _report_data):
    return env.get_template("report-template.j2").render(
        name_and_surname=_name_and_surname,
        report_date=_report_date,
        report_data=_report_data,
    )


name_and_surname, report_date, report_data_file = sys.argv[1], sys.argv[2], sys.argv[3]
with open(report_data_file, "r") as f:
    report_data_raw = f.read()

# HACK: from bash array to Python list :facepalm:
report_data = literal_eval("[" + report_data_raw.replace(")(", "), (") + "]")
report_data = [entry for entry in report_data if entry[1]]

html_text = render_template(
    _name_and_surname=name_and_surname,
    _report_date=report_date,
    _report_data=report_data,
)

html = HTML(string=html_text)
css = CSS(str(current_directory / "report-template.css"))

html.write_pdf(
    str(current_directory.parent / "my-work-reports" / f"{report_date}.pdf"),
    stylesheets=[css],
)
