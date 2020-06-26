# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.5.0
#   kernelspec:
#     display_name: Julia 1.4.2
#     language: julia
#     name: julia-1.4
# ---

# # Seaborn

# +
using Seaborn
const sns = Seaborn
using Pandas
using PyCall: pyimport, @py_str

# Refer these issues
# https://stackoverflow.com/questions/27835619/urllib-and-ssl-certificate-verify-failed-error/42334357#42334357
# https://github.com/ytdl-org/youtube-dl/issues/4816#issuecomment-455840010
certifi = pyimport("certifi")
ENV["SSL_CERT_FILE"]=certifi.where();
# -

# ## Scatter plot
#
# - https://seaborn.pydata.org/examples/scatterplot_matrix.html
#
# ```python
# # Python
# import seaborn as sns
# sns.set(style="ticks")
#
# df = sns.load_dataset("iris")
# sns.pairplot(df, hue="species")
# ```

# ### Julia implementation

df = sns.load_dataset("iris")
head(df, 10)

pairplot(df, hue="species")

# # KDE
#
# https://seaborn.pydata.org/examples/multiple_joint_kde.html
#
# ```python
# import seaborn as sns
# import matplotlib.pyplot as plt
#
# sns.set(style="darkgrid")
# iris = sns.load_dataset("iris")
#
# # Subset the iris dataset by species
# setosa = iris.query("species == 'setosa'")
# virginica = iris.query("species == 'virginica'")
#
# # Set up the figure
# f, ax = plt.subplots(figsize=(8, 8))
# ax.set_aspect("equal")
#
# # Draw the two density plots
# ax = sns.kdeplot(setosa.sepal_width, setosa.sepal_length,
#                  cmap="Reds", shade=True, shade_lowest=False)
# ax = sns.kdeplot(virginica.sepal_width, virginica.sepal_length,
#                  cmap="Blues", shade=True, shade_lowest=False)
#
# # Add labels to the plot
# red = sns.color_palette("Reds")[-2]
# blue = sns.color_palette("Blues")[-2]
# ax.text(2.5, 8.2, "virginica", size=16, color=blue)
# ax.text(3.8, 4.5, "setosa", size=16, color=red)
# ```

# ### Julia implementation

sns.set(style="darkgrid")
iris = sns.load_dataset("iris")
setosa = query(iris, :(species=="setosa"))
virginica = query(iris, :(species=="virginica"))
fig, ax = sns.subplots(figsize=(8,8))
ax = sns.kdeplot(setosa.sepal_width, setosa.sepal_length,
            cmap="Reds", shade=true, shade_lowest=false)
ax = sns.kdeplot(virginica.sepal_width, virginica.sepal_length,
                 cmap="Blues", shade=true, shade_lowest=false)
# Add labels to the plot
red = sns.seaborn.color_palette("Reds")[end-2]
blue = sns.seaborn.color_palette("Blues")[end-2]
ax.text(2.5, 8.2, "virginica", size=16, color=blue)
ax.text(3.8, 4.5, "setosa", size=16, color=red)
