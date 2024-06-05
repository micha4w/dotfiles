export function dump(obj : any) {
    return JSON.stringify(obj, function(key, val) {
        return (typeof val === 'function') ? '' + val : val;
    })
}