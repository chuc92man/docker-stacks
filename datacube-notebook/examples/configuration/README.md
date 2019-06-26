# Filename convetion

Files that match the regex pattern "\d{2}-config.&ast;" are used with Helm, as options for installing/upgrading a chart, through the `--values` option.\
All other files are used with `kubectl apply` using the `-f` option.
