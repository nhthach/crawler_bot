/**
 * ActionRoute
 */
export default class Action {
    name = undefined;
    action = undefined;
    defaultAction = undefined;

    constructor(name, action, defaultAction) {
        try {
            this.name = name;
            this.action = action;
            this.defaultAction = defaultAction;
        } catch (e) {
        }
    }

    isActiveAction(hashedPath) {
        return hashedPath.replace('#', '') === this.name;
    }
}
