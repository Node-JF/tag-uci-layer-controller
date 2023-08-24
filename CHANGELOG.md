#### 1.1

- Updated the virtual tree logic so that all layers being set to `false` and updated *before* layers being set to `true`. This is to help make transitions appear smoother when many layers are being updated at once.
- Added `Delay In` and `Delay Out` controls to add state-specific delays to layer transitions. See [Delay In](/README.md#delay-in) & [Delay Out](/README.md#delay-out)