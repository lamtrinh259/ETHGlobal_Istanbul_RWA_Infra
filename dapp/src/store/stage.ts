import { atom } from 'jotai'

export enum Stage {
    uploading = 1,
    describe,
    value,
    confirm
}

export const stageAtom = atom(Stage.uploading);