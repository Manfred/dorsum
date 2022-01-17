# Dorsum

[Generate an OAuth password](https://twitchapps.com/tmi/) for your account.

    dorsum config --username <username> --password <password>
    dorsum --channel teammanfred

If you also want to interact with the API you will need to create an app in the developer dashboars and set the `client_id` and `client_secret`.

## Development

    shards install
    crystal spec
