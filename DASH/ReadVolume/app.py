from dash import Dash, html, dcc, callback, Output, Input
import plotly.express as px
import pandas as pd
from databricks.sdk import WorkspaceClient
from io import BytesIO

w = WorkspaceClient(host = DATABRICKS_HOST, token = DATABRICKS_TOKEN)
response = w.files.download("/Volumes/prd_dash_lab/dash_data_science_unrestricted/shared_external_volume/penguins.csv")
downloaded_file = response.contents.read()

df = pd.read_csv(BytesIO(downloaded_file))

adelie = df[df['species'] == "Adelie"]
adelie.to_csv('adelie.csv', index=False)

with open("adelie.csv", mode="rb") as file:
    csv = file.read()

w.files.upload("/Volumes/prd_dash_lab/dash_data_science_unrestricted/shared_external_volume/adelie.csv", csv)

app = Dash()

# Requires Dash 2.17.0 or later
app.layout = [
    html.H1(children='Palmer Penguins Dash App', style={'textAlign':'center'}),
    dcc.Dropdown(df.species.unique(), 'Gentoo', id='dropdown-selection'),
    dcc.Graph(id='graph-content')
]

@callback(
    Output('graph-content', 'figure'),
    Input('dropdown-selection', 'value')
)
def update_graph(value):
    dff = df[df.species==value]
    return px.histogram(dff, x='body_mass_g')

if __name__ == '__main__':
    app.run(debug=True)
