# -reproduce-wrong-row-count
The InnoDB storage engine doesn't always keep the table rows counter uptodate. This Rspec example shows that behaviour

```
bundle install
rspec --order defined
```
