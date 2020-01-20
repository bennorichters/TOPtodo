---
image: https://repository-images.githubusercontent.com/218081395/e2f9aa00-2e22-11ea-9395-d6a897f88c0c
---

# TOPtodo

A mobile app that connects to [TOPdesk](https://topdesk.com). Quickly create an incident as a todo item. Fill in all required fields only once. A new todo item only requires a new brief description and optionally a longer request.

## Status

This app is currently under development and not yet available.

## How it works

![flow](./images/flow.png)

## TOPdesk authorization

You need to have the right authorization levels within TOPdesk to be able to use this app. Of course you need to be able to create incidents, but you also need to be allowed to use the _REST API_ and to create application passwords. You might need to contact your TOPdesk application manager to enable these.

![authorization-api](./images/authorization-api.png)

## Application password

The mobile app needs an _application password_. This is different from the normal password that is used to log into the TOPdesk web interface. You need to create a password yourself. See below how.

![create-application-password](./images/create-app-password.gif)

## Open Source

TOPtodo is an [open source project](https://github.com/bennorichters/TOPtodo/).
