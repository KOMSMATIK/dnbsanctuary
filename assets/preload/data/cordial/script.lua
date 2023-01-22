function onCreate()
for i = 0, getProperty('opponentStrums.length')-1 do
    setPropertyFromGroup('opponentStrums', i, 'texture', 'notes/NOTE_assets_3D');
end
for i = 0, getProperty('unspawnNotes.length')-1 do
    if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
    setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_assets_3D');
    end
end
end