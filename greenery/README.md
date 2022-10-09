# Greenery Data!
We deliver flowers and houseplants. This repository will contain the business logic we use to understand the state of the business and determine where how we can improve to grow revenue and acquire new customers. 

### Raw data
Raw data is stored in postgres. The source schemas are defined in `models/staging/postgres/_postgres__sources.yml`.

### Staging data 
Raw data is processed into staging tables that use business terminology in `models/staging`. 

### Marts data
Business logic will be defined in `models/marts`!

### Snapshots
We use snapshots to track changes of certain tables over time.


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

