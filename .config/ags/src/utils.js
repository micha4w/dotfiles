export function dump(obj) {
    return JSON.stringify(obj, function(key, val) {
        return (typeof val === 'function') ? '' + val : val;
    })
}