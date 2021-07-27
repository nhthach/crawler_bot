'use strict';
export default class Router {
    actionsDispatched = [];
    actionRoutes = undefined;

    constructor(actionRoutes) {
        this.actionRoutes = actionRoutes;
        this.init();
    }

    init() {
        let r = this.actionRoutes;
        (function(scope, r) {
            window.addEventListener('hashchange', function (e) {
                scope.hasChanged(scope, r);
            });
        })(this, r);
        this.hasChanged(this, r);
    }

    hasChanged(scope, r) {
        this.actionsDispatched.push(r.name);
        if (window.location.hash.length > 0) {
            for (let i = 0, length = r.length; i < length; i++) {
                let route = r[i];
                let actionData = window.location.hash.substr(1);
                actionData = actionData.split('?')[0];
                if(route.isActiveAction(actionData)) {
                    scope.takeAction(route.action);
                }
            }
        } else {
            let ix = 0;
            let length = r.length;
            for (; ix < length; ix++) {
                if(r[ix].defaultAction) {
                    scope.takeAction(r[ix].action);
                }
            }
        }
    }

    takeAction(action) {
        return typeof action === 'function' ?
            action(this.searchToObject()) : null;
    }

    searchToObject() {
        var s = window.location.hash.substring(window.location.hash.indexOf("?")+1);
        var pairs = s.split("&"), obj = {}, pair, i;
        for ( i in pairs ) {
            if ( pairs[i] === "" ) continue;
            pair = pairs[i].split("=");
            obj[ decodeURIComponent( pair[0] ) ] = decodeURIComponent( pair[1] );
        }
        return obj;
    }

    objectToSearch (obj) {
        let str = [];
        for (var p in obj)
            if (obj.hasOwnProperty(p)) {
                str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
            }
        return str.join("&");
    }

    goto(route, options) {
        let urlSearchParams = this.objectToSearch(options);
        urlSearchParams = urlSearchParams.length > 0 ? '?' + urlSearchParams : ''
        window.location.href = window.location.pathname + '#' + route + urlSearchParams;
    }
}
