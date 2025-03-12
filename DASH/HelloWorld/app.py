from dash import Dash, html, dcc, callback, Output, Input
import plotly.express as px
import pandas as pd

df = pd.read_csv('penguins.csv')

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