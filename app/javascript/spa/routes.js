import Router from 'spa/router'
import Action from 'spa/action'

export default class AppRouter {
    actions = [];
    routes = undefined;

    constructor() {}

    createAction(path, fn, isDefault) {
        this.actions.push(
            new Action(path, function (query) {
                fn(query)
            }, isDefault || false)
        )
    }

    goto(route, options) {
        this.routes.goto(route, options);
    }

    init() {
       this.routes = new Router(this.actions);
    }
}
