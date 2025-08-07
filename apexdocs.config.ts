export default {
  sourceDir: 'force-app',
  defaultGroupName: 'Classes',
  transformReference(reference) {
    return {
      ...reference,
      referencePath: reference.referencePath.replace(/.md$/, ''),
    }
  },
}
